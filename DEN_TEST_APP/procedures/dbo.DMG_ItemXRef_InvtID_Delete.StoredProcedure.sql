USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_ItemXRef_InvtID_Delete]    Script Date: 12/21/2015 15:36:51 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_ItemXRef_InvtID_Delete]
	@InvtID varchar(30)
AS

	DELETE FROM ItemXRef WHERE InvtID = @InvtID
GO
