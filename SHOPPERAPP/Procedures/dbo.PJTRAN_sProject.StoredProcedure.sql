USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJTRAN_sProject]    Script Date: 12/21/2015 16:13:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJTRAN_sProject] @parm1 varchar (16)  as
select * from PJTRAN
where
project like  @parm1
GO
