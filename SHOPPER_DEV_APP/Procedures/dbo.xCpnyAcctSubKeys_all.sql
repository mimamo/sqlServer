USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xCpnyAcctSubKeys_all]    Script Date: 12/16/2015 15:55:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[xCpnyAcctSubKeys_all] @parm1 varchar(50)  as
select * from xCpnyAcctSubKeys where 
tablename like @parm1  
order by  updseq
GO
