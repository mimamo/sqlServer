USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[xCustInvKeys_all]    Script Date: 12/21/2015 15:43:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[xCustInvKeys_all] @parm1 varchar(50)  as
select * from xCustInvKeys where 
tablename like @parm1  
order by  updseq
GO
