USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[xwhselockeys_all]    Script Date: 12/21/2015 15:37:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[xwhselockeys_all] @parm1 varchar(50)  as
select * from xwhselockeys where 
tablename like @parm1  
order by  updseq
GO
