USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[pjsubven_upd]    Script Date: 12/16/2015 15:55:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[pjsubven_upd]
	@VendID as char (15),
	@Vend_Name as char (60)

as

update pjsubven set vend_name = @Vend_Name
 where vendid = @VendID and @Vend_Name <> vend_name
GO
