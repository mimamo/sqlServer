USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJTIMWRK_INIT]    Script Date: 12/21/2015 15:43:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJTIMWRK_INIT] as
select * from PJTIMWRK
where
Report_accessnbr = ' ' and
Linenbr = 0
GO
