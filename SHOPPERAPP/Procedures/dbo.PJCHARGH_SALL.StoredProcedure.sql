USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJCHARGH_SALL]    Script Date: 12/21/2015 16:13:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJCHARGH_SALL] @parm1 varchar (10)   as
select * from PJCHARGH
where    batch_id LIKE @parm1
order by batch_id
GO
