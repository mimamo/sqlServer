USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[RQMaterial_Dept_DBNAV]    Script Date: 12/21/2015 13:57:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.RQMaterial_Dept_DBNAV    Script Date: 9/4/2003 6:21:22 PM ******/

/****** Object:  Stored Procedure dbo.RQMaterial_Dept_DBNAV    Script Date: 7/5/2002 2:44:41 PM ******/

/****** Object:  Stored Procedure dbo.RQMaterial_Dept_DBNAV    Script Date: 1/7/2002 12:23:11 PM ******/

/****** Object:  Stored Procedure dbo.RQMaterial_Dept_DBNAV    Script Date: 1/2/01 9:39:36 AM ******/

/****** Object:  Stored Procedure dbo.RQMaterial_Dept_DBNAV    Script Date: 11/17/00 11:54:31 AM ******/

/****** Object:  Stored Procedure dbo.RQMaterial_Dept_DBNAV    Script Date: 10/25/00 8:32:16 AM ******/

/****** Object:  Stored Procedure dbo.RQMaterial_Dept_DBNAV    Script Date: 10/10/00 4:15:39 PM ******/

/****** Object:  Stored Procedure dbo.RQMaterial_Dept_DBNAV    Script Date: 10/2/00 4:58:14 PM ******/

/****** Object:  Stored Procedure dbo.RQMaterial_Dept_DBNAV    Script Date: 9/1/00 9:39:21 AM ******/

/****** Object:  Stored Procedure dbo.RQMaterial_DBNAV    Script Date: 03/31/2000 12:21:21 PM ******/

/****** Object:  Stored Procedure dbo.RQMaterial_DBNAV    Script Date: 2/2/00 12:18:19 PM ******/

/****** Object : Stored Procedure dbo.RQMaterial_DBNAV  Script Date: 02/18/98 06:28:00 PM ******/
CREATE Procedure [dbo].[RQMaterial_Dept_DBNAV] @Parm1 Varchar(10), @parm2 varchar(10) AS
Select RQItemReqDet.*, RQItemReqHdr.*, Vendor.Name from
RQItemReqHdr, RQItemReqDet
left outer join Vendor on
Vendor.VendID = RQItemReqDet.prefvendor
  where
RQItemReqDet.Status = 'AP' And
RQItemReqDet.Reqnbr = '' and
RQItemReqDet.materialtype = @parm1 and
RQItemReqDet.Dept = @parm2 and
RQItemReqDet.ItemReqNbr = RQItemReqHdr.ItemReqNbr and
RQItemReqDet.PurchaseFor <> 'DL' and
(RQItemReqHdr.Status = 'RQ'  OR RQItemReqHdr.Status = 'AP')
ORDER BY RQItemReqDet.ItemReqNbr, RQItemReqDet.LineNbr
GO
