USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[acctsubkeys_all]    Script Date: 12/21/2015 13:56:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[acctsubkeys_all] @parm1 varchar(50), @parm2 varchar (3) as
select * from acctsubkeys where 
tablename like @parm1 and
updseq like @parm2
order by tablename, updseq
GO
