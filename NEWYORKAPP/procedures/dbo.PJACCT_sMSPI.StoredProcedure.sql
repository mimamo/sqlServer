USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJACCT_sMSPI]    Script Date: 12/21/2015 16:01:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJACCT_sMSPI] @parm1 varchar (1)  as
select * from PJACCT
where ca_id20 like @parm1
order by acct
GO
