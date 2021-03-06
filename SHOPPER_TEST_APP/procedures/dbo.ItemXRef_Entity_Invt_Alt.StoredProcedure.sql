USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ItemXRef_Entity_Invt_Alt]    Script Date: 12/21/2015 16:07:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ItemXRef_Entity_Invt_Alt    Script Date: 4/17/98 10:58:18 AM ******/
/****** Object:  Stored Procedure dbo.ItemXRef_Entity_Invt_Alt    Script Date: 4/16/98 7:41:52 PM ******/
Create Procedure [dbo].[ItemXRef_Entity_Invt_Alt] @parm1 varchar ( 15), @parm2 varchar ( 01), @parm3 varchar ( 30), @parm4 varchar ( 30) As
        Select * from ItemXRef where
                ((EntityID = @parm1 And AltIDType = @parm2)
                or AltIDType In ('G','O','M')) And
                InvtID Like @parm3 And
                AlternateID Like @parm4
        Order By AltIDType, EntityID, AlternateID
GO
