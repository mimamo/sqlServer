USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJLABDLY_SMAXLINE]    Script Date: 12/16/2015 15:55:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJLABDLY_SMAXLINE]  @parm1 varchar (10)   as
select max(linenbr) from PJLABDLY
where    docnbr     =  @parm1
GO
