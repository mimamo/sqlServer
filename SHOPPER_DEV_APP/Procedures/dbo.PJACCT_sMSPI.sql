USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJACCT_sMSPI]    Script Date: 12/16/2015 15:55:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJACCT_sMSPI] @parm1 varchar (1)  as
select * from PJACCT
where ca_id20 like @parm1
order by acct
GO
