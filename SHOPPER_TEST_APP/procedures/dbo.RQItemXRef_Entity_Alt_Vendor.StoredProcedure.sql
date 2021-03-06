USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[RQItemXRef_Entity_Alt_Vendor]    Script Date: 12/21/2015 16:07:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.RQItemXRef_Entity_Alt_Vendor    Script Date: 9/4/2003 6:21:21 PM ******/

/****** Object:  Stored Procedure dbo.RQItemXRef_Entity_Alt_Vendor    Script Date: 7/5/2002 2:44:41 PM ******/

/****** Object:  Stored Procedure dbo.RQItemXRef_Entity_Alt_Vendor    Script Date: 1/7/2002 12:23:11 PM ******/

/****** Object:  Stored Procedure dbo.RQItemXRef_Entity_Alt_Vendor    Script Date: 1/2/01 9:39:36 AM ******/

/****** Object:  Stored Procedure dbo.RQItemXRef_Entity_Alt_Vendor    Script Date: 11/17/00 11:54:30 AM ******/

/****** Object:  Stored Procedure dbo.RQItemXRef_Entity_Alt_Vendor    Script Date: 10/25/00 8:32:16 AM ******/

/****** Object:  Stored Procedure dbo.RQItemXRef_Entity_Alt_Vendor    Script Date: 10/10/00 4:15:38 PM ******/

/****** Object:  Stored Procedure dbo.RQItemXRef_Entity_Alt_Vendor    Script Date: 10/2/00 4:58:14 PM ******/

/****** Object:  Stored Procedure dbo.RQItemXRef_Entity_Alt_Vendor    Script Date: 9/1/00 9:39:20 AM ******/
Create Procedure [dbo].[RQItemXRef_Entity_Alt_Vendor] @parm1 varchar ( 10), @parm2 varchar ( 01), @parm3 varchar ( 30) As
        Select * from ItemXRef where
                ((EntityID = @parm1 And AltIDType = @parm2)
                or AltIDType In ('G','O','M')) And
                AlternateID Like @parm3
        Order By AltIDType Desc,EntityID, AlternateID
GO
