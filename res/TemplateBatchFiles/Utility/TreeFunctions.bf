/*---------------------------------------------------------*/

function computeTotalDivergence (treeID)
{
	ExecuteCommands ("bNames = BranchName   ("+treeID+",-1);");
	ExecuteCommands ("bLen   = BranchLength ("+treeID+",-1);");
	
	sum  = 0;
	sum2 = 0;
	
	
	for (_k=0; _k<Columns(bNames); _k=_k+1)
	{
		aNodeName = bNames[_k];
		sum  = sum + bLen[_k]*multFactors[aNodeName];
		sum2 = sum2 + bLen[_k];
	}	
	return {{sum,sum2}};
}

/*---------------------------------------------------------*/

function computeMultFactors (treeID)
{
	ExecuteCommands ("treeAVL2 = "+treeID + " ^ 0;leafCount=Max(2,TipCount("+treeID+"));"); 
	
	multFactors = {};
	
	for (_k=1; _k<Abs(treeAVL2); _k += 1)
	{
		aNode			= treeAVL2[_k];
		aNodeName		= aNode["Name"];
		parentIndex		= aNode["Parent"];
		_k2				= Abs(aNode["Children"]);
		if (_k2)
		{
			currentDepth		   = aNode["Below"];
			multFactors[aNodeName] = currentDepth;		
			if (parentIndex > 0)
			{
				(treeAVL2[parentIndex])["Below"] += currentDepth;
			}
		}
		else
		{
			multFactors[aNodeName]		= 1;
			(treeAVL2[parentIndex])["Below"] += 1;
		}
		
	}

	pKeys 			= Rows(multFactors);
	for (_k=0; _k<Columns(pKeys); _k=_k+1)
	{
		aNodeName = pKeys[_k];
		multFactors[aNodeName] = multFactors[aNodeName] * (leafCount-multFactors[aNodeName]);
	}
	
	return 0;
}

