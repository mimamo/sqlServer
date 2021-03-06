USE [DEN_TEST_APP]
GO
/****** Object:  View [dbo].[EDItemXRefOneEntityRef]    Script Date: 12/21/2015 14:10:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE View [dbo].[EDItemXRefOneEntityRef] As
Select InvtId, Max(AlternateId) 'AlternateId', AltIdType, EntityId 
From ItemXRef Where EntityId <> '*'
Group By InvtId, EntityId, AltIdType
GO
