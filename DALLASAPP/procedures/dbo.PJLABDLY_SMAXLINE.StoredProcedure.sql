USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJLABDLY_SMAXLINE]    Script Date: 12/21/2015 13:45:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJLABDLY_SMAXLINE]  @parm1 varchar (10)   as
select max(linenbr) from PJLABDLY
where    docnbr     =  @parm1
GO
