USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[pjexpdet_srecon]    Script Date: 12/21/2015 15:49:26 ******/
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
