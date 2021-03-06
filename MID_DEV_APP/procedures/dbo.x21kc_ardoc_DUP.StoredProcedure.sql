USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[x21kc_ardoc_DUP]    Script Date: 12/21/2015 14:18:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[x21kc_ardoc_DUP] @parm1 varchar(15), @parm2 varchar(15) as 
select a.custid, a.refnbr from ardoc a, ardoc x where 
a.doctype = 'PA'
and a.custid = @parm1 
and x.custid = @parm2  
and a.doctype = x.doctype  
and a.refnbr = x.refnbr
--and a.batnbr = x.batnbr
--and a.batseq = x.batseq
order by a.custid, a.doctype, a.refnbr, a.batnbr, a.batseq
GO
