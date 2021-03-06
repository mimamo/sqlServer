USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[APDoc_Avail_for_Payment]    Script Date: 12/21/2015 13:56:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.APDoc_Avail_for_Payment    Script Date: 4/7/98 12:19:54 PM ******/
/****** Object:  Stored Procedure dbo.APDoc_Avail_for_Payment    Script Date: 2/7/98 8:29:23 AM ******/
Create Procedure [dbo].[APDoc_Avail_for_Payment] @parm1 varchar ( 10), @parm2 varchar(10) as
Select apdoc.*, vendor.vendid, vendor.status, vendor.multichk, vendor.classid  from APDoc, Vendor
where
APDoc.DocType  in ('AC','AD','PP','VO')
and APDoc.Status = 'A'
and APDoc.CpnyID like @parm1
and APDoc.RefNbr  like  @parm2
and APDoc.OpenDoc  =  1
and APDoc.Rlsed    =  1
and APDoc.Selected = 0
and APDoc.VendId   =  Vendor.VendId
and Vendor.Status <> 'H'
GO
