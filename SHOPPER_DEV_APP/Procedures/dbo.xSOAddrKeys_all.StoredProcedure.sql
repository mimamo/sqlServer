USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xSOAddrKeys_all]    Script Date: 12/21/2015 14:34:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[xSOAddrKeys_all] @parm1 varchar(50)  as
select * from xSOAddrKeys where 
tablename like @parm1  
order by  updseq
GO
