USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[ItemXRef_InvtID_Type_Ent]    Script Date: 12/21/2015 13:44:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ItemXRef_InvtID_Type_Ent    Script Date: 4/17/98 10:58:18 AM ******/
/****** Object:  Stored Procedure dbo.ItemXRef_InvtID_Type_Ent    Script Date: 4/16/98 7:41:52 PM ******/
Create Procedure [dbo].[ItemXRef_InvtID_Type_Ent] @parm1 varchar ( 30), @parm2 varchar ( 1), @parm3 varchar ( 15) As
	Select * from ItemXRef where
		InvtID    = @parm1  And
		AltIDType = @parm2  And
		EntityID  = @parm3
GO
