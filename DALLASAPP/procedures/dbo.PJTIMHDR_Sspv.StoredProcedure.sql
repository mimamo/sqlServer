USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJTIMHDR_Sspv]    Script Date: 12/21/2015 13:45:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJTIMHDR_Sspv] @parm1 varchar (10) , @parm2 varchar (10)   as
select * from PJTIMHDR
where    preparer_id like @parm1 and
Docnbr      Like @parm2 and
th_status <> 'X'
order by preparer_id, docnbr desc, th_type, th_date desc
GO
