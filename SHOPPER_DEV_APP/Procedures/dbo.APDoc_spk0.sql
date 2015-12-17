USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[APDoc_spk0]    Script Date: 12/16/2015 15:55:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[APDoc_spk0] @parm1 varchar (10)  as
select * from APDoc
where    RefNbr  LIKE @parm1
and    DocType =    'VO'
and    Status  =    'A'
order by RefNbr,
DocType
GO
