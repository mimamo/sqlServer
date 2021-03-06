USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[APDoc_Avail_for_Payment_VM]    Script Date: 12/21/2015 14:17:32 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.APDoc_Avail_for_Payment_VM    Script Date: 11/18/98 8:29:23 AM ******/
Create Procedure [dbo].[APDoc_Avail_for_Payment_VM] @parm1 varchar ( 10), @parm2 varchar(10) as
Select apdoc.*, vendor.vendid, vendor.status, vendor.multichk, vendor.classid  from APDoc, Vendor
where
APDoc.DocType  in ('AC','AD','PP','VO', 'VM')
and APDoc.Status = 'A'
and APDoc.CpnyID like @parm1
and APDoc.RefNbr  like  @parm2
and APDoc.OpenDoc  =  1
and APDoc.Rlsed    =  1
and APDoc.Selected = 0
and APDoc.S4Future11 <> 'VM'
and APDoc.VendId   =  Vendor.VendId
and Vendor.Status <> 'H'
GO
