USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xInvLSKeys_all]    Script Date: 12/21/2015 13:36:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[xInvLSKeys_all] @parm1 varchar(50)  as
select * from xInvLSKeys where 
tablename like @parm1  
order by  updseq
GO
