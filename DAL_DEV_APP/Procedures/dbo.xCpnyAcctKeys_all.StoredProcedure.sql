USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xCpnyAcctKeys_all]    Script Date: 12/21/2015 13:35:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[xCpnyAcctKeys_all] @parm1 varchar(50)  as
select * from xCpnyAcctKeys where 
tablename like @parm1  
order by  updseq
GO
