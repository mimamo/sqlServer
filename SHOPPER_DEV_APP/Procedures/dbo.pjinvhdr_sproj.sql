USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[pjinvhdr_sproj]    Script Date: 12/16/2015 15:55:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pjinvhdr_sproj] @parm1 varchar (16)  as
select * from pjinvhdr where
pjinvhdr.project_billwith = @parm1
order by invoice_date, invoice_num
GO
