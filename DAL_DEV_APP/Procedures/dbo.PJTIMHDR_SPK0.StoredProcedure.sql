USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJTIMHDR_SPK0]    Script Date: 12/21/2015 13:35:50 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJTIMHDR_SPK0] @parm1 varchar (10)  as
select * from PJTIMHDR
where    docnbr = @parm1
GO
