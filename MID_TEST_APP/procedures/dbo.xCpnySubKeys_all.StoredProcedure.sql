USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[xCpnySubKeys_all]    Script Date: 12/21/2015 15:49:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[xCpnySubKeys_all] @parm1 varchar(50)  as
select * from xCpnySubKeys where 
tablename like @parm1  
order by  updseq
GO
