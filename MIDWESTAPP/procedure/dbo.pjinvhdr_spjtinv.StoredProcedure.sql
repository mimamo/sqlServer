USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[pjinvhdr_spjtinv]    Script Date: 12/21/2015 15:55:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pjinvhdr_spjtinv] @parm1 varchar (16), @parm2 varchar(10)  as
select * from pjinvhdr, pjproj where
pjinvhdr.project_billwith like @parm1
and pjinvhdr.invoice_num like @parm2
and pjinvhdr.inv_status in ('PO', 'PR')
and pjinvhdr.project_billwith = pjproj.project
order by doctype desc, invoice_num
GO
