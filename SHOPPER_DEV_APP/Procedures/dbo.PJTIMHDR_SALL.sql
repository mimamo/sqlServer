USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJTIMHDR_SALL]    Script Date: 12/16/2015 15:55:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJTIMHDR_SALL] @parm1 varchar (10) , @parm2 varchar (10)   as
select * from PJTIMHDR
where    preparer_id = @parm1 and
Docnbr Like @parm2 and
th_status <> 'X'
order by preparer_id, docnbr desc, th_type, th_date desc
GO
