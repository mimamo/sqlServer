USE [DALLASAPP]
GO
/****** Object:  View [dbo].[EDItemXRef_MaxGlobal]    Script Date: 12/21/2015 13:44:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE View [dbo].[EDItemXRef_MaxGlobal] As
Select InvtId, Max(AlternateId) 'AlternateId', AltIdType From ItemXRef Where EntityId = '*' Group By InvtId, AltIdType
GO
