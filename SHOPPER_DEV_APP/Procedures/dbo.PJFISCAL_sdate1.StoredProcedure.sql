USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJFISCAL_sdate1]    Script Date: 12/21/2015 14:34:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJFISCAL_sdate1] @parm1 smalldatetime  as
select * from PJFISCAL
where   end_date >= @parm1
order by end_date
GO
