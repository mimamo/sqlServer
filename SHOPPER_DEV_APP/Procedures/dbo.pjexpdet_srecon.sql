USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[pjexpdet_srecon]    Script Date: 12/16/2015 15:55:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create procedure [dbo].[pjexpdet_srecon] @parm1 varchar (10)   as
select * from pjexpdet D, pjexphdr H
where  d.docnbr = h.docnbr and
h.employee = @parm1
order by d.docnbr, d.linenbr
GO
