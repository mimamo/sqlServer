USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PCSETUP_SPK0]    Script Date: 12/21/2015 15:37:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PCSETUP_SPK0] as
select * from PCSETUP
order by setupid
GO
