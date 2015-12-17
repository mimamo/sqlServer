USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[FlexDef_SegCount]    Script Date: 12/16/2015 15:55:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[FlexDef_SegCount] @FieldClass varchar (15) as
	Select SegLength00 + SegLength01 + SegLength02 + SegLength03 + SegLength04 + SegLength05 + SegLength06 + SegLength07
	From flexdef
	Where FieldClassName = @FieldClass
GO
