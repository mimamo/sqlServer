USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[xalt_PJprojex_sALL]    Script Date: 12/21/2015 13:45:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[xalt_PJprojex_sALL] @parm1 varchar (16)  as
select * from xalt_PJprojex
where DefaultType like @parm1
order by DefaultType
GO
