USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[xTaskkeys_all]    Script Date: 12/21/2015 16:01:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[xTaskkeys_all] @parm1 varchar(50)  as
select * from xTaskkeys where 
tablename like @parm1  
order by  updseq
GO
