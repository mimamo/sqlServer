USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDItemXRef_RefLookUp]    Script Date: 12/16/2015 15:55:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDItemXRef_RefLookUp] @AlternateId varchar(30), @EntityId varchar(15), @AltIdType varchar(1) As
Select InvtId From ItemXRef Where AlternateId = @AlternateId And EntityId In ('*',@EntityId) And AltIdType = AltIdType
Order By EntityId Desc
GO
