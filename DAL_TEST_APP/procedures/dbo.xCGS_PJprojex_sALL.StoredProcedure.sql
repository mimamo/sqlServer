USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[xCGS_PJprojex_sALL]    Script Date: 12/21/2015 13:57:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[xCGS_PJprojex_sALL] @parm1 varchar (16)  as
select * from xCGS_PJprojex
where DefaultType like @parm1
order by DefaultType
GO
