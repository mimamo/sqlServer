USE [NEWYORKAPP]
GO
/****** Object:  View [dbo].[xvr_AR002_Note]    Script Date: 12/21/2015 16:00:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xvr_AR002_Note]

as

SELECT a.ItemID, a.MaxTimeLastModified, ISNULL(b.WLVName, '') as 'WLVName', b.TableName, ISNULL(b.COName, '') as 'COName', b.Note
FROM (SELECT max(xCustomNote.TimeLastModified) as 'MaxTimeLastModified', xCustomNote.ItemID
		FROM xCustomNote LEFT JOIN xCustomNoteWatchListValue ON xCustomNote.CustomNoteWatchListValueID = xCustomNoteWatchListValue.CustomNoteWatchListValueID
			LEFT JOIN xCustomNoteWatchListValueColorOption ON xCustomNoteWatchListValue.CustomNoteWatchListValueColorOptionID = xCustomNoteWatchListValueColorOption.CustomNoteWatchListValueColorOptionID
		WHERE xCustomNote.TableName = 'PJINVHDR'
		GROUP BY xCustomNote.ItemID) a LEFT JOIN (SELECT xCustomNote.ItemID, xCustomNote.TimeLastModified, xCustomNoteWatchListValue.Name as 'WLVName', xCustomNote.TableName, xCustomNoteWatchListValueColorOption.Name as 'COName', xCustomNote.Note
													FROM xCustomNote LEFT JOIN xCustomNoteWatchListValue ON xCustomNote.CustomNoteWatchListValueID = xCustomNoteWatchListValue.CustomNoteWatchListValueID
														LEFT JOIN xCustomNoteWatchListValueColorOption ON xCustomNoteWatchListValue.CustomNoteWatchListValueColorOptionID = xCustomNoteWatchListValueColorOption.CustomNoteWatchListValueColorOptionID
													WHERE xCustomNote.TableName = 'PJINVHDR') b ON a.MaxTimeLastModified = b.TimeLastModified
GO
