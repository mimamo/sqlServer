USE [DENVERAPP]
GO
/****** Object:  View [dbo].[EDItemXRef_MaxGlobal]    Script Date: 12/21/2015 15:42:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE View [dbo].[EDItemXRef_MaxGlobal] As
Select InvtId, Max(AlternateId) 'AlternateId', AltIdType From ItemXRef Where EntityId = '*' Group By InvtId, AltIdType
GO
