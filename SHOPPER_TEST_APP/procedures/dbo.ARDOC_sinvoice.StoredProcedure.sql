USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARDOC_sinvoice]    Script Date: 12/21/2015 16:06:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure  [dbo].[ARDOC_sinvoice] @parm1 varchar (15) , @parm2 varchar (10)   as
select * from  ARDOC
where ARDOC.custid      =  @parm1 and
ARDOC.doctype     =  'IN'   and
ARDOC.refnbr      =  @parm2
order by ARDOC.custid, ARDOC.doctype, ARDOC.refnbr
GO
