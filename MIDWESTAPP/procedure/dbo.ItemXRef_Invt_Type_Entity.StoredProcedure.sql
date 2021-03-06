USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[ItemXRef_Invt_Type_Entity]    Script Date: 12/21/2015 15:55:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ItemXRef_Invt_Type_Entity    Script Date: 4/17/98 10:58:18 AM ******/
/****** Object:  Stored Procedure dbo.ItemXRef_Invt_Type_Entity    Script Date: 4/16/98 7:41:52 PM ******/
Create Procedure [dbo].[ItemXRef_Invt_Type_Entity] @parm1 varchar ( 30), @parm2 varchar ( 01), @parm3 varchar ( 15) As
        Select * from ItemXRef where
                InvtID Like @parm1 And
                ((AltIDType Like @parm2 And EntityID Like @parm3)
		 		or AltIDType In ('G','O','M'))
        Order By AltIDType,InvtID,EntityID
GO
