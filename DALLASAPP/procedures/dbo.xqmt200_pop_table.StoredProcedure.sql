USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[xqmt200_pop_table]    Script Date: 12/21/2015 13:45:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[xqmt200_pop_table] 
@Parm1 char(6) 
as 
insert into XQMT2SCR 
(GCISTA, GCOCTA, GCORLTA, GCOTA, GCPTA, MEICE, MEIEOD, MEMEI, MEOCC, MEOCSSC, MEOERC, MEOGE, MEPayroll, MESC, Period, 
STDS, STF, STO, STS, user1, user2, user3, user4, user5, user6) 
values (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, @Parm1, 0, 0, 0, 0, '', '', '', 0, 0, 0)
GO
