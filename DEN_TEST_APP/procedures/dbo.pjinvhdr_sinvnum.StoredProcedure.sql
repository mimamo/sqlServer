USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[pjinvhdr_sinvnum]    Script Date: 12/21/2015 15:37:01 ******/
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
