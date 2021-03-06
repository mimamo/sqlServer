USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[pjinvhdr_sinvnum]    Script Date: 12/16/2015 15:55:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pjinvhdr_sinvnum] @parm1 varchar (16), @parm2 varchar (10) as
select pjinvhdr.*, customer.name, pjproj.* from pjinvhdr, customer, pjproj
where pjinvhdr.project_billwith like @parm1
and pjinvhdr.invoice_num = @parm2
and pjinvhdr.inv_status in ('PO', 'PR')
and pjinvhdr.customer = customer.custid
and pjinvhdr.project_billwith = pjproj.project
order by invoice_num
GO
