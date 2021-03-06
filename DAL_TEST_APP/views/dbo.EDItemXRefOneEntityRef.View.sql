USE [DAL_TEST_APP]
GO
/****** Object:  View [dbo].[EDItemXRefOneEntityRef]    Script Date: 12/21/2015 13:56:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE View [dbo].[EDItemXRefOneEntityRef] As
Select InvtId, Max(AlternateId) 'AlternateId', AltIdType, EntityId 
From ItemXRef Where EntityId <> '*'
Group By InvtId, EntityId, AltIdType
GO
