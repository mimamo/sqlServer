USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[wcpv_SOType]    Script Date: 12/21/2015 13:35:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[wcpv_SOType](
	@CpnyID VARCHAR(10) = '%',
	@SOTypeID VARCHAR(4) = '%'
)As
	SELECT	RTRIM(s.Descr) as Descr, s.CpnyID, s.SOTypeID
	FROM	SOType s
	WHERE	s.CpnyID LIKE @CpnyID
	AND	s.SOTypeID LIKE @SOTypeID
	ORDER BY s.Descr
GO
