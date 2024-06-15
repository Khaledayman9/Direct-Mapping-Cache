
convertBinToDec(B,D):-
		convertBinToDec(B,1,D).

convertBinToDec(0,_,0).
convertBinToDec(B,M,D):-
		B > 0,
		Y is mod(B,10),
		B1 is B // 10,
		M1 is M*2,
		convertBinToDec(B1,M1,D1),
		D is D1 + Y*M.

replaceIthItem(Item,[H|T],I,[H|Result]):-
		I1 is I - 1,
		replaceIthItem(Item,T,I1,Result).
		
	
replaceIthItem(Item,[_|T],0,[Item | T]).

splitEvery(N,List,Res):-
		length(List,L),
		L > N,
		splitEvery(N,List,0,[],[],Res).

splitEvery(_,[],_,TmpGroup,TmpResult,Res):-
		append(TmpResult,[TmpGroup], Res).

splitEvery(N,[H|T],I,TmpGroup,TmpResult,Res):-
		I = N,
		append(TmpResult,[TmpGroup],TmpResult1),
		splitEvery(N,[H|T],0,[],TmpResult1,Res).

splitEvery(N,[H|T],I,TmpGroup,TmpResult,Res):-
		I \= N,
		I1 is I + 1,
		append(TmpGroup, [H], TmpGroup1),
		splitEvery(N,T,I1,TmpGroup1,TmpResult,Res).

roundUp(Number,Y):-
		Y is round(Number),
		Y >= Number.

roundUp(Number,Res):-
		Y is round(Number),
		Y < Number,
		Res is Y + 1.

logBase2(Num,Res):-
		Res1 is log(Num)/log(2),
		roundUp(Res1,Res).

getNumBits(_,fullyAssoc,_,0).

getNumBits(NumOfSets,setAssoc,_,BitsNum):-
			logBase2(NumOfSets,BitsNum).

getNumBits(_,directMap,Cache,BitsNum):-
			length(Cache,L),
			logBase2(L,Tmp),
			roundUp(Tmp,BitsNum).
			
fillZeros(R,0,R).
fillZeros(String,N,R):-
			N > 0,	
			string_concat(0,String,String1),
			N1 is N - 1,
			fillZeros(String1,N1,R).

convertAddress(B,0,B,'',directMap).
convertAddress(B,BitsNum,T,I,directMap):- 
	 BitsNum>0,
     BitsNum1 is BitsNum-1,
     Y is mod(B,10),	 
	 B1 is B//10,
	 convertAddress(B1,BitsNum1,T,I1,directMap),
	 string_concat(I1,Y,I2),
	 atom_number(I2,I).

getDataFromCache(SA,Cache,Data,HopsNum,directMap,BitsNum):-
   atom_number(SA,SA1),
   convertAddress(SA1,BitsNum,Tag,I,directMap),
   convertBinToDec(I,I1),
   findGData(Cache,Tag,0,I1,Data,HopsNum).

findGData([item(tag(Tag1),data(Data),1,_)|_],Tag,I,I,Data,0):-
    atom_number(Tag1,Tag2),
	Tag2 = Tag.

findGData([H|T],Tag,C,I,Data,HopsNum):-
   C < I,
   C1 is C+1,
   findGData(T,Tag,C1,I,Data,HopsNum).
    
getByIndex([H|_],0,H).
getByIndex([_|T],I,R):-
				I > 0,
				I1 is I - 1,
				getByIndex(T,I1,R).	
	
replaceInCache(Tag,Idx,Mem,OldCache,NewCache,Data, directMap,BitsNum):-
	getNumBits(_,directMap,OldCache,BitsNum),
	atom_number(StringTag, Tag),
	atom_length(StringTag, LT),
	NZeros1 is 6 - BitsNum - LT,
    fillZeros(Tag,NZeros1, TagZeros),
    atom_number(StringIdx, Idx),
	atom_length(StringIdx, IdxLength),
	ZerosForIdx is BitsNum - IdxLength,
	fillZeros(Idx,ZerosForIdx,IdxZeros),
	write(IdxZeros),
	string_concat(TagZeros,IdxZeros,AddressString),
	atom_number(AddressString,AddressBin),
	convertBinToDec(AddressBin, AddressDec),
	getByIndex(Mem, AddressDec, Data),
	convertBinToDec(Idx,IdxDec),
	length(OldCache,CacheLength),
	IdxDecMod is IdxDec mod CacheLength,
	replaceIthItem(item(tag(TagZeros),data(Data),1,0),OldCache,IdxDecMod,NewCache).
	
getData(StringAddress,OldCache,Mem,NewCache,Data,HopsNum,directMap,BitsNum,hit):-
   getDataFromCache(StringAddress,OldCache,Data,HopsNum,directMap,BitsNum),
   NewCache = OldCache.
getData(StringAddress,OldCache,Mem,NewCache,Data,HopsNum,directMap,BitsNum,miss):-
   \+getDataFromCache(StringAddress,OldCache,Data,HopsNum,directMap,BitsNum),
   atom_number(StringAddress,Address),
   convertAddress(Address,BitsNum,Tag,Idx,directMap),
   replaceInCache(Tag,Idx,Mem,OldCache,NewCache,Data,directMap,BitsNum).

runProgram([],OldCache,_,OldCache,[],[],directMap,_).
runProgram([Address|AdressList],OldCache,Mem,FinalCache,[Data|OutputDataList],[Status|StatusList],directMap,NumOfSets):-
    getNumBits(NumOfSets,directMap,OldCache,BitsNum),
	(directMap = setAssoc, Num = NumOfSets; directMap \= setAssoc, Num = BitsNum),
    getData(Address,OldCache,Mem,NewCache,Data,HopsNum,directMap,Num,Status),
    runProgram(AdressList,NewCache,Mem,FinalCache,OutputDataList,StatusList,directMap,NumOfSets).

	


	 
