USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[IRLTDetail_4145000]    Script Date: 12/21/2015 15:55:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[IRLTDetail_4145000]
	@LeadFormulaID VarChar(10)
As
Select
	*
From
	 IRLTDetail
Where
	LeadTimeID Like @LeadFormulaID
Order By
	LeadTimeID,
	PriorPeriodNbr

-- Copyright 1998, 1999, 2000, 2001 by Solomon Software, Inc. All rights reserved.
GO
