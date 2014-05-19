/*
 * Copyright (C) 2014 Canonical, Ltd.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */


#ifndef MOCKRESULTSMODEL_H
#define MOCKRESULTSMODEL_H

#include <unity/shell/scopes/ResultsModelInterface.h>

class MockResultsModel : public unity::shell::scopes::ResultsModelInterface
{
    Q_OBJECT

public:
    explicit MockResultsModel(int result_count, int categoryId, QObject* parent = 0);

    int rowCount(const QModelIndex& parent = QModelIndex()) const override;
    QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const override;

    /* getters */
    QString categoryId() const override;
    int count() const override;

    /* setters */
    void setCategoryId(QString const& id) override;

private:
    QHash<int, QByteArray> m_roles;
    int m_result_count;
    int m_categoryId;
};

#endif
