USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ItemXRef_Entity_Alt]    Script Date: 12/16/2015 15:55:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ItemXRef_Entity_Alt    Script Date: 4/17/98 10:58:18 AM ******/
/****** Object:  Stored Procedure dbo.ItemXRef_Entity_Alt    Script Date: 4/16/98 7:41:52 PM ******/
Create Procedure [dbo].[ItemXRef_Entity_Alt] @parm1 varchar ( 15), @parm2 varchar ( 01), @parm3 varchar ( 30) As
        Select * from ItemXRef where
                ((EntityID = @parm1 And AltIDType = @parm2)
                or AltIDType In ('G','O','M')) And
                AlternateID Like @parm3
        Order By AltIDType,EntityID, AlternateID
GO
