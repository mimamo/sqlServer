USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDPackIndicator_SpecificChk]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDPackIndicator_SpecificChk] @InvtId varchar(30) As
Select Count(*) From EDPackIndicator Where IndicatorType = 2 And InvtId = @InvtId
GO
